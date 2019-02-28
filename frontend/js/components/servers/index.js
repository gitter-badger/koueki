import React from "react";
import { Form } from "semantic-ui-react";
import { get } from "utils";
import { NavLink } from "react-router-dom";
import ReactTable from "react-table";

export default class ServerList extends React.Component {
    state = { servers: [] }

    getServers = async () => {
        let resp = await get("/v2/servers/");
        let json = await resp.json();
        this.setState({servers: json});
    }

    async componentDidMount() {
        this.getServers();
    }

    render() {
        const columns = [
            { Header: "ID", accessor: "id" }, 
            { Header: "Name", accessor: "name" },
            { Header: "URL", accessor: "url" }
        ];

        return (
            <ReactTable
                data={this.state.servers}    
                columns={columns}
            />            
        );
    }    
}
