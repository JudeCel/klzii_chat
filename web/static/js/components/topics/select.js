import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Dropdown, Button, SplitButton, MenuItem }    from 'react-bootstrap'
import Actions            from '../../actions/topic';

const Select = React.createClass({
  changeTopic(event) {
    const { dispatch, channel } = this.props;

    let id = event.target.id;
    dispatch(Actions.changeTopic(channel, id));
  },
  render() {
    const { current, topics, session } = this.props;

    return (
      <div className='col-md-2 topic-select-section'>
        <div className='topic-select-box'>
          <div>
            { session.name }
          </div>

          <Dropdown id='topic-selector' bsSize='large'>
            <Button className='no-border-radius'>
              { current.name }
            </Button>
            <Dropdown.Toggle className='no-border-radius' />
            <Dropdown.Menu className='no-border-radius'>
              {
                topics.map((topic) => {
                  return (
                    <MenuItem id={ topic.id } key={ 'topic-' + topic.id } active={ current.id == topic.id }>{ topic.name }</MenuItem>
                  )
                })
              }
            </Dropdown.Menu>
          </Dropdown>

          <i className='viewers-section icon-eye'>
            <small>3</small>
          </i>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    session: state.chat.session,
    channel: state.topic.channel,
    current: state.topic.current,
    topics: state.topic.all,
  };
};

export default connect(mapStateToProps)(Select);
