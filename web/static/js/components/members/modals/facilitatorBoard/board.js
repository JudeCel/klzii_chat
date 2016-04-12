import React, {PropTypes} from 'react';
import Editor             from 'react-medium-editor';

const Board = React.createClass({
  getInitialState() {
    return {
      content: this.props.content || "aaaaaaa",
      options: {
        toolbar: { buttons: ['bold', 'italic', 'anchor'] }
      }
    };
  },
  onChange(content) {
    this.setState({ content: content });
  },
  render() {
    const { content, options } = this.state;

    return (
      <Editor text={ content } onChange={ this.onChange } options={ options } />
    )
  }
});

export default Board;
