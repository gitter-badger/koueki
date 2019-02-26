import { get, post } from "utils";
import { put, takeLatest } from "redux-saga/effects";
import { SEND_ATTRIBUTE_SEARCH, RECV_ATTRIBUTE_SEARCH, SEARCH_ATTRIBUTES } from "actions/attributes";

function* searchAttributes({data}) {
    const searchParams = Object.assign({}, data, {returnFormat: "json"});
    yield put({type: SEND_ATTRIBUTE_SEARCH, data: searchParams});

    const response = yield post("/v2/attributes/search", searchParams);
    const numPages = response.headers.get("X-result-count");
    const json = yield response.json();
    yield put({type: RECV_ATTRIBUTE_SEARCH, attributes: json, pages: numPages });
}

export default function* watchAttributeSearch() {
    yield takeLatest(SEARCH_ATTRIBUTES, searchAttributes);
}
