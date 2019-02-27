defmodule Koueki.Repo.Migrations.AddAttributeSearchTable do
  use Ecto.Migration

  def change do
    execute("""
    CREATE MATERIALIZED VIEW attribute_search AS
      SELECT
        attributes.id AS id,
        (to_tsvector(unaccent(attributes.comment))) as comment,
        (to_tsvector(unaccent(coalesce(string_agg(tags.name, ' '), ' ')))) as tags,
        (to_tsvector(unaccent(coalesce(string_agg(attributes.category, ' '), ' ')))) as category,
        (to_tsvector(unaccent(coalesce(string_agg(attributes.type, ' '), ' ')))) as type,
        (to_tsvector(unaccent(coalesce(string_agg(attributes.value, ' '), ' ')))) as value
      FROM attributes
      LEFT JOIN attribute_tags
        ON attribute_tags.attribute_id = attributes.id
      LEFT JOIN tags
        ON attribute_tags.tag_id = tags.id OR attribute_tags.tag_id = tags.id
      GROUP BY attributes.id
    """)

    execute("""
      CREATE OR REPLACE FUNCTION refresh_attribute_search()
      RETURNS TRIGGER LANGUAGE plpgsql
      AS $$
      BEGIN
        REFRESH MATERIALIZED VIEW CONCURRENTLY attribute_search;
        RETURN NULL;
      END $$;
    """)

    execute("""
      CREATE TRIGGER refresh_attribute_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON attributes
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_attribute_search();
    """)

    execute("""
      CREATE TRIGGER refresh_attribute_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON attribute_tags
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_attribute_search();
    """)

    execute("""
    CREATE TRIGGER refresh_attribute_search
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
    ON tags
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_attribute_search();
    """)

    create index("attribute_search", ["comment", "tags", "category", "value"], using: :gin)
    create unique_index("attribute_search", [:id])
  end
end
