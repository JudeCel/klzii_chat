import React, {PropTypes} from 'react';

const Badge = React.createClass({
  selectClass() {
    return `badge ${this.props.type}`;
  },
  render() {
    const { data, type } = this.props;
    
    let val = data && data[type] ? data[type] : "";

    return (
      <span className={ this.selectClass() }>{ val }</span>
    )
  }
});

export default Badge;
