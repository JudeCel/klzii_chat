import React, {PropTypes}         from 'react';
import { connect }                from 'react-redux';
import { Socket }                 from 'phoenix';
import { FormGroup, FormControl } from 'react-bootstrap';
import LogsActions                from '../actions/logs';

const Logs = React.createClass({
  componentDidMount(){
    this.props.dispatch(LogsActions.connectToChannel());
  },
  handleFilterChange(key){
    return (e) => {
      let { channel } = this.props
    this.props.dispatch(LogsActions.change_filter(channel, {key: key, id: e.target.value} ));
   }
  },
  render(){
    const {logs, filters} = this.props
    return(
      <div>
        <br/>
        <div className="jumbotron">
          <div className="container">
            <FormGroup controlId="userId" className="col-md-3">
              <FormControl type="number"
                value={filters.userId || ""}
                placeholder="Filter by User id"
                onChange={this.handleFilterChange("userId")}
              />
            </FormGroup>
            <FormGroup controlId="accountId" className="col-md-3">
              <FormControl type="number"
                value={filters.accountId || ""}
                placeholder="Filter by Account id"
                onChange={this.handleFilterChange("accountId")}
              />
            </FormGroup>
            <FormGroup controlId="accountUserId" className="col-md-3">
              <FormControl type="number"
                value={filters.accountUserId || ""}
                placeholder="Filter by AccountUser Id"
                onChange={this.handleFilterChange("accountUserId")}
              />
            </FormGroup>
            <FormGroup controlId="limit" className="col-md-3">
              <FormControl type="number"
                value={filters.limit || ""}
                placeholder="Limit"
                onChange={this.handleFilterChange("limit")}
              />
            </FormGroup>
          </div>
        </div>
        <table className="table table-striped table-bordered table-hover">
            <thead>
              <tr>
                <th>ID</th>
                <th>Level</th>
                <th>Application</th>
                <th>User ID</th>
                <th>Account User ID</th>
                <th>Account User Role</th>
                <th>Account ID</th>
                <th>Path</th>
                <th>Response status</th>
                <th>Response Time</th>
                <th>Details</th>
              </tr>
            </thead>
            <tbody>
              {
                logs.map((entry) =>
                  <tr key={entry.id}>
                    <td>{entry.id}</td>
                    <td>{entry.level}</td>
                    <td>{entry.application}</td>
                    <td>{entry.userId}</td>
                    <td>{entry.accountUserId}</td>
                    <td>{entry.accountUserRole}</td>
                    <td>{entry.accountId}</td>
                    <td>{entry.path}</td>
                    <td>{entry.response_status_code}</td>
                    <td>{entry.responseTime} ms</td>
                    <td>
                      <a className="btn btn-default" href={entry.details_url} target='_blank'>Details</a>
                    </td>
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
    logs: state.logs.collection,
    filters: state.logs.filters,
    channel: state.logs.channel

  }
};

export default connect(mapStateToProps)(Logs);
