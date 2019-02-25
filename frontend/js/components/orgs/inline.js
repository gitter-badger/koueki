import React from "react";
import { NavLink } from "react-router-dom";

const Org = ({ org: { id: id, name: name }}) => (
    <NavLink to={`/web/orgs/${id}`}>
        {name}
    </NavLink>
);

export default Org;
