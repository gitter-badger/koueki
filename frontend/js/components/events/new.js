import React from "react";
import { Form } from "semantic-ui-react";
import { post, format_error } from "utils";
import moment from "moment";
import { toast } from "react-toastify";
import EventForm from "events/form";

export default class NewEvent extends React.PureComponent {
  state = {
    info: "",
    date: moment().format("YYYY-MM-DD"),
    threat_level_id: 4,
    analysis: 0,
  }

  onChange = (e, {name, value}) => this.setState({[name]: value})

  submit = async () => {
    let resp = await post("/v2/events/", this.state);
    let json = await resp.json();
    if (resp.status == 201) {
      toast.success(`Event ${json.id} created, redirecting...`);
      this.props.history.push(`/web/events/${json.id}`);
    } else {
      toast.error(`Server says: ${resp.status}`);
      toast.error(format_error(json));
    }
  }

  render() {
    return (
        <EventForm
            value={this.state}
            onChange={this.onChange}
            onSubmit={this.submit}
        />            
    );
  } 
}

