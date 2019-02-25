import React from "react";
import { Form } from "semantic-ui-react";
import { post, format_error } from "utils";
import moment from "moment";
import { toast } from "react-toastify";

const EventForm = ({ onChange, value, onSubmit }) => (
  <Form inverted>
    <Form.Input
      name="info"
      label="Info"
      onChange={onChange}
      value={value.info}
    />

    <Form.Input
      type="date"
      name="date"
      label="Date"
      value={value.date}
      onChange={onChange}       
    />

    <Form.Group widths={3}>
      <Form.Dropdown
        name="threat_level_id"
        value={value.threat_level_id}
        label="Threat Level"
        options={[
          {text: "High", value: 1},
          {text: "Medium", value: 2},
          {text: "Low", value: 3},
          {text: "Unknown", value: 4}
        ]}
        onChange={onChange}
      />

      <Form.Dropdown
        name="analysis"
        value={value.analysis}
        label="Analysis"
        options={[
          {text: "Initial", value: 0},
          {text: "Ongoing", value: 1},
          {text: "Complete", value: 2}
        ]}
        onChange={onChange}
      />
    </Form.Group>

    <Form.Button
      color="grey"
      content="Save"
      onClick={onSubmit}
    />
  </Form>
);

export default EventForm;
