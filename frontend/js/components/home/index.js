import React from "react";
import { Header, Container } from "semantic-ui-react";

import RequireLoginStatus from "require-login-status";
import AttributeSearch from "attributes/search";
import AttributeList from "attributes/list";
import { NavLink } from "react-router-dom";

const Home = () => (
    <section>
      <Header as={"h2"} inverted>Welcome to Koueki</Header>
      <blockquote>公益, public benefit</blockquote>

      <Container text>
          Koueki is a lightweight malware information sharing
          server using <a href="https://github.com/MISP/misp-rfc" target="_blank">
          MISP's data format</a>
      </Container>

      <Container text>
         To get started, <NavLink to="/login">Login</NavLink>
      </Container>
    </section>
);

export default Home;
