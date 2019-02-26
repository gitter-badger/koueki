import { get, post } from "utils";
import { call, put, takeLatest } from "redux-saga/effects";
import { toast } from "react-toastify";
import { RECV_LOGIN_STATUS, REQUEST_CONFIG, setLoginStatus, RECV_CONFIG } from "actions/config";

function* configGetter() {
    try {
        let resp = yield call(get, "/instance/config");
        let json = yield resp.json();
        yield put({type: RECV_CONFIG, data: json});
        resp = yield call(get, "/v2/attributes/types/");
        json = yield resp.json();
        yield put({type: RECV_CONFIG, data: { types: json }});
        resp = yield call(get, "/v2/attributes/categories/");
        json = yield resp.json();
        yield put({type: RECV_CONFIG, data: { categories: json }});
    } catch (e) {
        console.error(e);
        toast.error("There was an error retrieving config");
        toast.error(e.toString());
    }
}

export default function* loginGetWatch() {
    yield takeLatest([RECV_LOGIN_STATUS, REQUEST_CONFIG], configGetter);
}
