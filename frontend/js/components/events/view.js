import React from "react";
import { connect } from "react-redux";
import { SEARCH_EVENTS } from "actions/events";
import { Header, Segment, Statistic, Label, Button } from "semantic-ui-react";
import { LocalAttributeList } from "attributes/list";
import { NavLink } from "react-router-dom";
import { analysisToText, analysisToColour, threatLevelToText, threatLevelToColour } from "utils";
import Org from "orgs/inline";

class ViewEvent extends React.Component {
    componentDidMount() {
        this.props.searchEvents({ id: this.props.match.params.id });
    }

    render() {
        const { events, loading } = this.props;
        if (loading) return "loading...";

        const event = events[0];

        return (
            <Segment inverted>
                <Header as="h1">Event {event.id}: {event.info}</Header>

                <Header as="h4">
                    Created by <Org org={event.org} />
                </Header>

                <Label.Group>
                    <Label color={event.published?"green":"red"}
                        content={event.published?"Published":"Unpublished"}
                    />
                    <Label color={analysisToColour(event.analysis)}
                        content="Analysis"
                        detail={analysisToText(event.analysis)}
                    />
                    <Label color={threatLevelToColour(event.threat_level_id)}
                        content="Threat Level"
                        detail={threatLevelToText(event.threat_level_id)}
                    />
                </Label.Group>


                <NavLink to={`${this.props.match.url}/attributes/add`}>
                    <Button content="Add attributes" icon="add" color="black"/>
                </NavLink>
                <LocalAttributeList attributes={event.attributes} />
            </Segment>
        );
    }
}

const mapStateToProps = ({ events: { events, loading }}) => ({
    events, loading
});

const mapDispatchToProps = dispatch => ({
    searchEvents: (params) => dispatch({type: SEARCH_EVENTS, data: params})
});

export default connect(mapStateToProps, mapDispatchToProps)(ViewEvent);
