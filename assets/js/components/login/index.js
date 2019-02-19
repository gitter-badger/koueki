import React from "react";
import { Form } from "semantic-ui-react";
import { connect } from "react-redux";
import { post } from "utils";

export default class LoginForm extends React.PureComponent {
  state = { email: "", password: "" }

  onChange = (e, {name, value}) => this.setState({[name]: value})

  submit = async () => {
    const postBody = {
      email: this.state.email,
      password: this.state.password
    }

    let response = await post("/api/login", postBody);
    let json = response.json();
    console.log(json);
  }

  render() {
    return (
      <Form inverted>
        <Form.Input
          name="email"
          label="Email"
          placeholder="my_user@mydomain.net"
          onChange={this.onChange}
        />
        <Form.Input
          type="password"
          name="password"
          label="Password"
          onChange={this.onChange}
        />

        <Form.Button
          color="black"
          content="Submit"
          onClick={this.submit}
        />
      </Form>
    );
  }
}
