import urljoin from "urljoin";

export const getURL = (path = "") => (
    urljoin("/", path)
);

export const getHeaders = (otherHeaders = {}) => ({
  headers: Object.assign({},
            {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            otherHeaders)
});

export const post = (url, body) => fetch(getURL(url), {method: "POST", body: JSON.stringify(body), ...getHeaders()})

export const get = (url) => fetch(getURL(url), {method: "GET", ...getHeaders()})
