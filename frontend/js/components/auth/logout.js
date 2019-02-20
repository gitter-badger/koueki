import React from "react";
import { post } from "utils";
import { toast } from "react-toastify";
import { withRouter } from "react-router-dom";

class Logout extends React.Component {
  async componentDidMount() {
    toast.info("Logging out...");
    await post("/auth/logout");
    toast.success("Logged out");
    this.props.history.push("/login");
  }

  render() {
    return "";
  }
}

export default withRouter(Logout);
