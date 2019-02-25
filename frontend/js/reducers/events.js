import { START_EVENT_SEARCH, SEARCH_EVENTS, RECV_EVENT_SEARCH, PATCH_EVENT } from "actions/events";

const initial_state = {
    events: [],
    loading: true,
    pages: -1,
    searchParams: {}
};

const resolvePatch = (events, patchedEvent) => {
    const baseEvent = events.filter(x => x.id == patchedEvent.id)[0];
    const index = events.indexOf(baseEvent);
    events.splice(index, 1, Object.assign({}, baseEvent, patchedEvent));
    return Array.from(events);
}

const events = (state = initial_state, action) => {
    switch (action.type) {
        case START_EVENT_SEARCH:
            return Object.assign({}, state, { loading: true, searchParams: action.data});
        case SEARCH_EVENTS:
            return Object.assign({}, state, { loading: true });
        case RECV_EVENT_SEARCH:
            return Object.assign({}, state, { loading: false, events: action.events, pages: action.pages });
        case PATCH_EVENT:
            return Object.assign({}, state, { events: resolvePatch(state.events, action.data)});
        default:
            return state;
    }
}

export default events;
