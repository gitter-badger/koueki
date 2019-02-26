import { put, takeEvery, fork, all } from "redux-saga/effects";
import getConfig from "sagas/getConfig";
import searchAttributes from "sagas/searchAttributes";
import searchEvents from "sagas/searchEvents";
import checkCredentials from "sagas/checkCredentials";

export default function* rootSaga() {
    yield all([
        fork(checkCredentials),
        fork(getConfig),
        fork(searchEvents),
        fork(searchAttributes)
    ])
}
