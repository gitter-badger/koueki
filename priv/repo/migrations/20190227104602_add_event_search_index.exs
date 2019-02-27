defmodule Koueki.Repo.Migrations.AddEventSearchIndex do
  use Ecto.Migration

  def change do
    execute("""
      CREATE EXTENSION IF NOT EXISTS unaccent
    """)

    execute(
    """
    CREATE MATERIALIZED VIEW event_search AS
      SELECT
        events.id AS id,
        (to_tsvector(unaccent(events.info))) as info,
        (to_tsvector(unaccent(coalesce(string_agg(tags.name, ' '), ' ')))) as tags,
        (to_tsvector(unaccent(coalesce(string_agg(attributes.category, ' '), ' ')))) as category,
        (to_tsvector(unaccent(coalesce(string_agg(attributes.type, ' '), ' ')))) as type,
        (to_tsvector(unaccent(coalesce(string_agg(attributes.value, ' '), ' ')))) as value
      FROM events
      LEFT JOIN event_tags
        ON event_tags.event_id = events.id
      LEFT JOIN attributes
        ON attributes.event_id = events.id
      LEFT JOIN attribute_tags
        ON attribute_tags.attribute_id = attributes.id
      LEFT JOIN tags
        ON event_tags.tag_id = tags.id OR attribute_tags.tag_id = tags.id
      GROUP BY events.id
    """)

    execute("""
      CREATE OR REPLACE FUNCTION refresh_event_search()
      RETURNS TRIGGER LANGUAGE plpgsql
      AS $$
      BEGIN
        REFRESH MATERIALIZED VIEW CONCURRENTLY event_search;
        RETURN NULL;
      END $$;
    """)

    execute("""
      CREATE TRIGGER refresh_event_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON events
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_event_search();
    """)

    execute("""
      CREATE TRIGGER refresh_event_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON event_tags
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_event_search();
    """)

    execute("""
      CREATE TRIGGER refresh_event_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON tags
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_event_search();
      """)

    execute("""
      CREATE TRIGGER refresh_event_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON attributes
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_event_search();
      """)

    execute("""
      CREATE TRIGGER refresh_event_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON attribute_tags
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_event_search();
      """)

    create index("event_search", ["info", "tags", "category", "value"], using: :gin)
  end
end
