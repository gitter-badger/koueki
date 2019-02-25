import React from "react";
import EventSearch from "events/search";
import EventList from "events/list";
import { Button } from "semantic-ui-react";
import { NavLink } from "react-router-dom";

const EventIndex = () => (
    <div>
        <NavLink to="/web/events/create">
            <Button content="Create New" icon="add" color="grey" />
        </NavLink>
        <EventSearch />
        <EventList />
    </div>
);

export default EventIndex;
