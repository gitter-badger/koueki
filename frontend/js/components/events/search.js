import React from "react";
import { Form } from "semantic-ui-react";
import { connect } from "react-redux";
import { SEARCH_EVENTS } from "actions/events";
import SearchInput from "search/index";

class EventSearch extends React.PureComponent {
    state = {
        params: {info: ""}
    }

    submit = () => {
        this.props.search(this.state.params);
    }

    render() {
        const validSearch = {
            "id": "integer",
            "info": "string",
        };

        return (
            <Form inverted>
                <SearchInput
                    parameters={validSearch}
                    value={this.state.params}
                    onChange={(e, value) => this.setState({params: value})}
                />
                <Form.Button
                    color="grey"
                    onClick={this.submit}
                    icon="search"
                    content="Search"
                    fluid
                />
            </Form>
        );
    }
}

const mapDispatchToProps = dispatch => ({
    search: (term) => dispatch({type: SEARCH_EVENTS, data: term})
});

export default connect(null, mapDispatchToProps)(EventSearch);
