import React from "react";
import { Form } from "semantic-ui-react";
import { post, format_error } from "utils";
import moment from "moment";
import { toast } from "react-toastify";

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
      this.props.history.push(`/events/${json.id}`);
    } else {
      toast.error(`Server says: ${resp.status}`);
      toast.error(format_error(json));
    }
  }

  render() {
    return (
      <Form inverted>
        <Form.Input
          name="info"
          label="Info"
          onChange={this.onChange}
          value={this.state.info}
        />

        <Form.Input
          type="date"
          name="date"
          label="Date"
          value={this.state.date}
          onChange={this.onChange}       
        />

        <Form.Group widths={3}>
          <Form.Dropdown
            name="threat_level_id"
            value={this.state.threat_level_id}
            label="Threat Level"
            options={[
              {text: "High", value: 1},
              {text: "Medium", value: 2},
              {text: "Low", value: 3},
              {text: "Unknown", value: 4}
            ]}
            onChange={this.onChange}
          />

          <Form.Dropdown
            name="analysis"
            value={this.state.analysis}
            label="Analysis"
            options={[
              {text: "Initial", value: 0},
              {text: "Ongoing", value: 1},
              {text: "Complete", value: 2}
            ]}
            onChange={this.onChange}
          />
        </Form.Group>

        <Form.Button
          color="grey"
          content="Create Event"
          onClick={this.submit}
        />
      </Form>
    );
  } 
}

