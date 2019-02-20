import React from "react";
import { post } from "utils";
import { toast } from "react-toastify";
import { withRouter } from "react-router-dom";
import { connect } from "react-redux";
import { setLoginStatus } from "actions/config";

class Logout extends React.Component {
  async componentDidMount() {
    console.log(this.props);
    toast.info("Logging out...");
    this.props.setLoginStatus(false);
    await post("/auth/logout");
    toast.success("Logged out");
    this.props.history.push("/");
  }

  render() {
    return "";
  }
}

const mapDispatchToProps = ({
    setLoginStatus
});

export default withRouter(connect(null, mapDispatchToProps)(Logout));
