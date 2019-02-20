export const RECV_LOGIN_STATUS = "RECV_LOGIN_STATUS";
export const RECV_CONFIG = "RECV_CONFIG";
export const REQUEST_CONFIG = "REQUEST_CONFIG";

export const setLoginStatus = (status) => ({
    type: RECV_LOGIN_STATUS,
    data: status
});
