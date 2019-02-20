import React from "react";
import { connect } from "react-redux";

const RequireLoginStatus = ({ status, loggedIn, children }) => {
  if (status === loggedIn) return children;
  return null;
};

const mapStateToProps = ({ config: { loggedIn }}) => ({
  loggedIn
});

export default connect(mapStateToProps)(RequireLoginStatus);
