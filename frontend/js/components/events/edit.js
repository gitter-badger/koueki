import React from "react";
import { Button, Form, Modal } from "semantic-ui-react";
import { patch, format_error } from "utils";
import { toast } from "react-toastify";
import EventForm from "events/form";
import { connect } from "react-redux";
import { PATCH_EVENT } from "actions/events";

class EditEvent extends React.Component {
  state = {
    open: false,
  }

  onChange = (e, {name, value}) => this.setState({[name]: value})

  submit = async () => {
    console.log(this.state);
    let resp = await patch(`/v2/events/${this.props.event.id}`, this.state);
    let json = await resp.json();
    if (resp.status == 200) {
      toast.success("Event edited!");
      // Patch over our locally-held event
      this.props.patch(json);      
      this.setState({open: false});
    } else {
      toast.error(`Server says: ${resp.status}`);
      toast.error(format_error(json));
    }
  }

  render() {
    return (
        <Modal
            basic
            open={this.state.open}
            onOpen={() => this.setState({open: true, ...this.props.event})}
            onClose={() => this.setState({open: false})}
            closeIcon
            trigger={<Button
                color="grey"
                onClick={() => this.setState({open: true})}
                content="Edit event"
                icon="edit"
            />}
        >
            <Modal.Content>
                <EventForm
                    value={this.state}
                    onChange={this.onChange}
                    onSubmit={this.submit}
                />            
            </Modal.Content>
        </Modal>
    );
  } 
}

const mapDispatchToProps = dispatch => ({
    patch: event => dispatch({type: PATCH_EVENT, data: event})
});

export default connect(null, mapDispatchToProps)(EditEvent);
