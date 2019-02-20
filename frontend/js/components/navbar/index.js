import React from "react";
import PropTypes from "prop-types";
import { Menu, Image, Icon, Label } from "semantic-ui-react";
import { NavLink } from "react-router-dom";
import { withRouter } from "react-router";
import { connect } from "react-redux";
import ConfigChanger from "config/index";
import RequireLoginStatus from "require-login-status";

class NavBar extends React.Component {
    render() {

        const centralNav = [
            { name: "Events", link: "/events" },
            { name: "Attributes", link: "/attributes" }
        ];

        return (
            <Menu borderless inverted stackable>
                <Menu.Item>
                    <NavLink
                        to="/"
                    >
                      <h2>公益</h2>
                    </NavLink>
                </Menu.Item>

                <Menu.Menu>
                    <RequireLoginStatus status={true}>
                        { centralNav.map((navElement, key) => (
                            <Menu.Item key={key}>
                                <NavLink to={navElement.link}>{navElement.name}</NavLink>
                            </Menu.Item>
                        ))}
                    </RequireLoginStatus>
                </Menu.Menu>
                <Menu.Menu position="right">
                  <Menu.Item>
                    <RequireLoginStatus status={false}>
                      <NavLink to="/login">Login</NavLink>  
                    </RequireLoginStatus>
                    <RequireLoginStatus status={true}>
                      <NavLink to="/logout">Logout</NavLink>  
                    </RequireLoginStatus>
                  </Menu.Item>
                </Menu.Menu>
            </Menu>
        );
    }
}

export default withRouter(NavBar);
