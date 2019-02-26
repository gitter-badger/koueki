import { get, post } from "utils";
import { call, put, takeLatest } from "redux-saga/effects";
import { toast } from "react-toastify";
import { setLoginStatus } from "actions/config";

function* checkCredentials() {
    try {
        let resp = yield call(get, "/authcheck/");
        let json = yield resp.json();
        if (resp.status == 200) {
            yield put(setLoginStatus(true));
        } else {
            yield put(setLoginStatus(false));
        }
    } catch (e) {
    }
}

export default function* credentialCheckWatcher() {
    yield takeLatest("persist/PERSIST", checkCredentials);
}
