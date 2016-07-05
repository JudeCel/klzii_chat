const builder = {
  addImageAndFrame(svg, group, data, item) {
    let rect = this.createMainRect(svg, data, item);

    if(item.resource) {
      let image = this.createMainImage(svg, data, item);
      this.addDeleteButton(rect, image, svg, group, data, item);
    }
    else {
      group.add(rect);
    }
  },
  addDeleteButton(rect, image, svg, group, data, item) {
    if(item.permissions.can_delete) {
      let semi = this.createDeleteImage(svg, data, item);
      group.add(rect, image, semi);
    }
    else {
      group.add(rect, image);
    }
  },
  createMainRect(svg, data, item) {
    return svg.rect(data.x, data.y, data.width + data.border, data.height + data.border, 5).attr({ fill: 'white', stroke: item.colour, strokeWidth: data.border });
  },
  createMainImage(svg, data, item) {
    return svg.image(item.resource.url.full, data.x + data.border/2, data.y + data.border/2, data.width, data.height);
  },
  createDeleteImage(svg, data, item) {
    let remove = svg.image('/images/svgControls/remove.png', data.x-data.border, data.y-data.border, 25, 25);
    let frame = svg.rect(data.x - data.border, data.y - data.border, 15 + data.border, 15 + data.border).attr({ fill: 'white', stroke: 'black', strokeWidth: 1 });
    return svg.group(frame, remove).addClass('cursor-pointer remove-button').click(this.removePinboardResource.bind(this, item.id));
  },
  setNextPositionForPinboard(startX, data, item) {
    if(data.item % 4 == 0) {
      data.x = startX;
      data.y += data.space*2 + data.height + data.border*2;
    }
    else {
      data.x += data.space + data.width + data.border*2;
    }
    data.item++;
  },
  startingData() {
    return {
      x: 45,
      y: 45,
      width: 180,
      height: 150,
      space: 10,
      border: 10,
      item: 1
    };
  }
}

export default builder;
