import { get, post } from "utils";
import { put, takeLatest } from "redux-saga/effects";
import { SEARCH_EVENTS, START_EVENT_SEARCH, RECV_EVENT_SEARCH } from "actions/events";

function* searchEvents({data}) {
    const searchParams = Object.assign({}, data, {returnFormat: "json"});
    yield put({type: START_EVENT_SEARCH, data: searchParams});
    const response = yield post("/v2/events/search/", searchParams);
    const numPages = response.headers.get("X-Page-Count");
    const json = yield response.json();
    yield put({type: RECV_EVENT_SEARCH, events: json, pages: numPages });
}

export default function* watchEventSearch(test) {
    yield takeLatest(SEARCH_EVENTS, searchEvents);
}
