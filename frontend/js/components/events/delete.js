import React from "react";
import { Button, Confirm } from "semantic-ui-react";
import { withRouter } from "react-router-dom";
import { delete_req } from "utils";
import { toast } from "react-toastify";

class DeleteEvent extends React.PureComponent {
    state = { open: false }
    submit = async () => {
        const { id: id } = this.props.event;
        const req = await delete_req(`/v2/events/${id}`) 
        const resp = await req.json();
        if (req.status == 200) {
            toast.success(`Event ${id} deleted.`);
            this.props.history.push("/web/events/");
        } else {
            toast.error("Something happened!");
            toast.error(resp);
        }        
    }

    render() {
        return (
            <div>
                <Confirm 
                    header={`Delete event ${this.props.event.id}`}
                    open={this.state.open}
                    confirmButton="Confirm"
                    cancelButton="Cancel Delete"
                    onConfirm={this.submit}
                    onCancel={() => this.setState({open: false})}
                />

                <Button onClick={() => this.setState({open: true})} 
                    color="grey"
                    type="button" content="Delete Event"
                    icon="delete"
                />
            </div>
        );
    }
}

export default withRouter(DeleteEvent);
