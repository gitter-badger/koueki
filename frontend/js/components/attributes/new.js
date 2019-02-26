import React from "react";
import { Form } from "semantic-ui-react";
import { connect } from "react-redux";
import { post, splitLines } from "utils";
import { toast } from "react-toastify";
import { withRouter } from "react-router-dom";
import { format_error } from "utils";

class CreateAttribute extends React.PureComponent {
    state = {
        value: "",
        category: "Network activity",
        type: "ip-dst"
    }

    onChange = (e, {name, value}) => this.setState({[name]: value})

    onTypeChange = (e, {name, value}) => {
        const type = this.props.types[value];

        if (!type.valid_for.includes(value)) {
            this.setState({[name]: value, category: type.defaults.category})
        } else {
            this.setState({[name]: value})
        }
    }

    submit = async () => {
        const { match: { params: { id: id }}} = this.props;

        const toAdd = splitLines(this.state.value).map(x => ({
            value: x, category: this.state.category, type: this.state.type
        }));

        let resp = await post(`/v2/events/${id}/attributes/`, toAdd);
        let json = await resp.json();
        if (resp.status == 201) {
            toast.success(`Added ${json.length} attributes`);
            this.props.history.push(`/web/events/${id}`);
        } else {
            toast.error(`Server says: ${resp.status}`);
            toast.error(format_error(resp));
        }
    }

    render() {
        return (
            <Form inverted>
                <Form.TextArea
                    rows={10}
                    name="value"
                    label="Value"  
                    value={this.state.value}
                    placeholder="Values (1 per line)"
                    onChange={this.onChange}
                />
                <Form.Group>
                    <Form.Dropdown
                        name="type"
                        label="Type"
                        search
                        fluid
                        width={8}
                        value={this.state.type}
                        onChange={this.onTypeChange}
                        options={Object.keys(this.props.types).map(x => ({             
                            text: x, value: x
                        }))}                
                    />

                    <Form.Dropdown
                        name="category"
                        label="Category"
                        search
                        fluid
                        width={8}
                        value={this.state.category}
                        onChange={this.onChange}
                        options={
                            this.props.categories
                            .filter(x => 
                                this.props.types[this.state.type].valid_for.includes(x))
                            .map(x => ({
                                text: x, value: x
                            }))
                        }                
                    />
                </Form.Group>
                <Form.Button fluid onClick={this.submit} type="button"
                    content="Submit" icon="add" color="grey" />
            </Form>
        );
    }
}

const mapStateToProps = ({ config: { types: types, categories: categories }}) => ({
    types, categories
});

export default withRouter(connect(mapStateToProps)(CreateAttribute));
