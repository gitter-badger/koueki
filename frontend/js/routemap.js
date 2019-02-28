import loadable from "loadable-components";
import React from "react";
import { Segment } from "semantic-ui-react";

const Placeholder = () => (
    <Segment loading />
);
const load_options = { LoadingComponent: () => <Placeholder /> };

const routes = [
    { path: "/", component: () => import("home/index"), public: true },
    { path: "/login", component: () => import("auth/login"), public: true },
    { path: "/logout", component: () => import("auth/logout") },
    { path: "/attributes", component: () => import("attributes/index") },
    { prefix: "/events", components: [
        { path: "/", component: () => import("events/index") },
        { path: "/create", component: () => import("events/new") },
        { path: "/:id", component: () => import("events/view") },
        { path: "/:id/attributes/add", component: () => import("attributes/new") }
    ]},
    { prefix: "/servers", components: [
        { path: "/create", component: () => import("servers/new") }
    ]}
];

const process_components = (components, base_route="") => {
    var flattened = [];
    components.forEach(c => {
        if (c.prefix) {
            // It's a sub-route, recurse
            const sub_components = process_components(c.components, base_route + c.prefix);
            flattened = flattened.concat(sub_components);
        } else {
            // It's a leaf, append to flattened
            flattened.push({ path: base_route + c.path,
                component: loadable(c.component,load_options),
                public: c.public
            });
        }
    });

    return flattened;
};

const async_routes = process_components(routes, "/web");

export default async_routes;
