import React from "react";
import { Form } from "semantic-ui-react";
import { connect } from "react-redux";

const AttributeTypeDropdown = ({ types, ...props }) => (
    <Form.Dropdown
        {...props}
        search
        fluid
        selection
        options={types.map(type => ({ text: type, value: type}))}
    />
);

const mapAttributeTypesToProps = ({ config: { types: types }}) => ({
    types: Object.keys(types)
});

export default connect(mapAttributeTypesToProps)(AttributeTypeDropdown);
