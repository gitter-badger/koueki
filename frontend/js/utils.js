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
            otherHeaders),
  credentials: "include"
});

export const post = (url, body) => fetch(getURL(url), {method: "POST", body: JSON.stringify(body), ...getHeaders()})

export const get = (url) => fetch(getURL(url), {method: "GET", ...getHeaders()})

export const patch = (url, body) => fetch(getURL(url), {method: "PATCH", body: JSON.stringify(body), ...getHeaders()})

export const delete_req = (url) => fetch(getURL(url), {method: "DELETE", ...getHeaders()})

export const format_error = ({ error: errors }) => {
  let error_message = "";
  Object.keys(errors).forEach(key => {
    error_message += `${key}: ${errors[key].join(", ")}, `;
  });
  return error_message;
}

export const splitLines = value => {
    return value.split("\n").map(x => x.trim()).filter(x => x != "");
}

export const analysisToText = analysis => {
    return ["Initial", "Ongoing", "Complete"][analysis];
}

export const analysisToColour = analysis => {
    return ["red", "orange", "green"][analysis];
}

export const threatLevelToText = threatLevel => {
    return ["", "High", "Medium", "Low", "Undefined"][threatLevel];
}

export const threatLevelToColour = threatLevel => {
    return ["", "red", "orange", "yellow", "blue"][threatLevel];
}
