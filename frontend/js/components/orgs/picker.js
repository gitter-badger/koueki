import React from "react";
import { Form } from "semantic-ui-react";
import { get } from "utils";

export default class OrgPicker extends React.Component {
    state = { orgs: [] }

    getOrgs = async () => {
        let resp = await get("/v2/orgs/");
        let json = await resp.json();
        this.setState({orgs: json});
    }

    async componentDidMount() {
        this.getOrgs();
    }

    render() {
        return (
            <Form.Group>
                <Form.Dropdown
                    options={this.state.orgs.map(org => ({
                        text: `${org.name} (${org.uuid})`, value: org.id
                    }))}
                    {...this.props}
                />
                <Form.Button size="small" color="grey" icon="refresh"  
                    onClick={this.getOrgs} type="button" content="Refresh Orgs" />
            </Form.Group>
        );
    }
}
