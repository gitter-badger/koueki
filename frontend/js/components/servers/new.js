import React from "react";
import { Form } from "semantic-ui-react";
import { post, format_error } from "utils";
import { withRouter } from "react-router-dom";
import { toast } from "react-toastify";

class NewServer extends React.PureComponent {
    state = {
        name: "", url: "", apikey: "", push_enabled: true, pull_enabled: true,
        skip_ssl_validation: false, server_certificate: null,
        client_certificate: null, adapter: "koueki",
        enable_client_cert: false, enable_server_cert: false
    }

    onChange = (e, {name, value}) => this.setState({[name]: value})
    checkboxOnChange = (e, {name, checked}) => this.setState({[name]: checked})

    submit = async () => {
        const { name, url, apikey, push_enabled, pull_enabled, skip_ssl_validation,
                server_certificate, client_certificate, adapter } = this.state;

        const postBody = { 
            name, url, apikey, push_enabled, pull_enabled, skip_ssl_validation,
            server_certificate, client_certificate, adapter 
        };

        let resp = await post("/v2/servers/", postBody);
        let json = await resp.json();
        if (resp.status == 201) {
            toast.success("Created server")
            this.props.history.push("/web/servers");
        } else {
            toast.error(`Server says: ${resp.status}`);
            toast.error(format_error(json));
        }
    }

    render() {
        return (
            <Form inverted>
                <Form.Input
                    name="name"
                    label="Name"
                    placeholder="Friendly server name"
                    value={this.state.name}
                    onChange={this.onChange}
                />
                <Form.Input
                    name="url"
                    label="URL"
                    placeholder="Server base URL"
                    value={this.state.url}
                    onChange={this.onChange}
                />
                <Form.Input
                    name="apikey"
                    label="API Key"
                    placeholder="Your API key for the server"
                    value={this.state.apikey}
                    onChange={this.onChange}
                />
                <Form.Dropdown
                    name="adapter"
                    label="Adapter"
                    onChange={this.onChange}
                    value={this.state.adapter}
                    options={[
                        { value: "koueki", text: "Koueki" },
                        { value: "misp", text: "MISP" }
                    ]}
                />

                <Form.Group>
                    <Form.Checkbox
                        name="push_enabled"
                        label="Push Enabled"
                        value={this.state.push_enabled}
                        onChange={this.checkboxOnChange}
                    />
                    <Form.Checkbox
                        name="pull_enabled"
                        label="Pull Enabled"
                        value={this.state.pull_enabled}
                        onChange={this.checkboxOnChange}
                    />                    
                </Form.Group>
                <Form.Checkbox
                    name="skip_ssl_validation"
                    label="Skip SSL Validation"
                    value={this.state.skip_ssl_validation}
                    onChange={this.checkboxOnChange}
                />

                <Form.Checkbox           
                    name="enable_client_cert"
                    label="Requires a client certificate"
                    value={this.state.enable_client_cert}
                    onChange={(e, {checked}) => {
                        if (checked) {
                            this.setState({enable_client_cert: true, client_certificate: ""})
                        } else {
                            this.setState({enable_client_cert: false, client_certificate: null});
                        }
                    }}
                />

                { this.state.enable_client_cert &&
                    <Form.TextArea
                        name="client_certificate"
                        label="Client Certificate"
                        value={this.state.client_certificate}
                        onChange={this.onChange}
                    />
                }

                <Form.Checkbox           
                    name="enable_server_cert"                       
                    label="Requires a server certificate"                     
                    value={this.state.enable_client_cert}                        
                    onChange={(e, {checked}) => {                                 
                        if (checked) {                                            
                            this.setState({enable_server_cert: true, server_certificate: ""})
                        } else {                                                      
                            this.setState({enable_server_cert: false, server_certificate: null});
                        }
                    }}
                />

                { this.state.enable_server_cert &&
                    <Form.TextArea
                        name="server_certificate"
                        label="Server Certificate"
                        value={this.state.server_certificate}
                        onChange={this.onChange}
                    />
                }
                <Form.Button content="Add Server" icon="add" color="grey" 
                    onClick={this.submit} />

            </Form>
        );
    }
}

export default withRouter(NewServer);
