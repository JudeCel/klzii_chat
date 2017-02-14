import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import { Socket }         from 'phoenix';
import { Button }         from 'react-bootstrap';
import LogsActions        from '../actions/logs';

const Logs = React.createClass({
  componentDidMount(){
    this.props.dispatch(LogsActions.connectToChannel());
  },
  loadData(){

  },
  render(){
    const {logs} = this.props
    return(
      <div>
        <table className="table table-striped table-bordered table-hover">
            <thead>
              <tr>
                <th>ID</th>
                <th>Level</th>
                <th>User ID</th>
                <th>Account User ID</th>
                <th>Account ID</th>
                <th>Response Time</th>
                <th>Meta</th>
                <th>Req</th>
                <th>Res</th>
              </tr>
            </thead>
            <tbody>
              {
                logs.map((entry) =>
                  <tr key={entry.id}>
                  <th scope="row">{entry.id}</th>
                  <td>{entry.userId}</td>
                  <td>{entry.level}</td>
                  <td>{entry.accountUserId}</td>
                  <td>{entry.accountId}</td>
                  <td>{entry.responseTime} ms</td>
                  <td><Button onClick={this.loadData.bind(this, entry.id, 'meta')}>Load Meta</Button></td>
                  <td><Button onClick={this.loadData.bind(this, entry.id, 'res')}>Load Request</Button></td>
                  <td><Button onClick={this.loadData.bind(this, entry.id, 'req')}>Load Response</Button></td>
                  </tr>
                )
              }
            </tbody>
          </table>
      </div>
    );
  }
})

const mapStateToProps = (state) => {
  return {
    logs: state.logs.collection
  }
};

export default connect(mapStateToProps)(Logs);
