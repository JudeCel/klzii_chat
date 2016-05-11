import React, {PropTypes} from 'react';

const Badge = React.createClass({
  selectClass() {
    return `badge ${this.props.type}`;
  },
  render() {
    const { data, type } = this.props;

    if(data && data[type]) {
      return (
        <span className={ this.selectClass() }>{ data[type] }</span>
      )
    }
    else {
      return (
        <span className={ this.selectClass() }></span>
      )
    }
  }
});

export default Badge;
