import React from "react";
import { Form } from "semantic-ui-react";
import { connect } from "react-redux";
import { post } from "utils";
import { setLoginStatus } from "actions/config";
import { toast } from "react-toastify";
import { withRouter } from "react-router-dom";

class LoginForm extends React.PureComponent {
  state = { email: "", password: "" }

  onChange = (e, {name, value}) => this.setState({[name]: value})

  submit = async () => {
    const postBody = {
      email: this.state.email,
      password: this.state.password
    }

    let response = await post("/auth/login", postBody);
    let json = response.json();
    if (json.error) {
      toast.error(json.error);
      this.props.setLoginStatus(false);
    } else {
      toast.success("Logged in");
      this.props.setLoginStatus(true); 
      this.props.history.push("/");
    }
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

const mapDispatchToProps = ({
  setLoginStatus
});

export default withRouter(connect(null, mapDispatchToProps)(LoginForm));
