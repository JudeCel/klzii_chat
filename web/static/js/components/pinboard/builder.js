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
    let semi = group.group();
    semi.add(rect, image);

    if(item.permissions.can_delete) {
      let remove = this.createDeleteImage(svg, data, item);
      group.add(semi, remove);
    }
    else {
      group.add(semi);
    }
  },
  createMainRect(svg, data, item) {
    return svg.rect(data.x, data.y, data.width + data.border, data.height + data.border, 5).attr({ fill: 'white', stroke: item.colour, strokeWidth: data.border });
  },
  createMainImage(svg, data, item) {
    return svg.image(item.resource.url.thumb, data.x + data.border/2, data.y + data.border/2, data.width, data.height);
  },
  createDeleteImage(svg, data, item) {
    let remove = svg.image('/images/svgControls/remove.png', data.x-data.border, data.y-data.border, 25, 25);
    let frame = svg.rect(data.x - data.border, data.y - data.border, 15 + data.border, 15 + data.border).attr({ fill: 'white', stroke: 'black', strokeWidth: 1 });
    return svg.group(frame, remove).addClass('cursor-pointer remove-button').click(this.removePinboardResource.bind(this, item.id));
  },
  setNextPositionForPinboard(startX, data, item) {
    if(data.item % 4 == 0) {
      data.x = startX;
      data.y += data.spaceTop + data.height + data.border*2;
    }
    else {
      data.x += data.spaceSide + data.width + data.border*2;
    }
    data.item++;
  },
  startingData() {
    return {
      x: 45,
      y: 55,
      width: 180,
      height: 125,
      spaceTop: 55,
      spaceSide: 10,
      border: 10,
      item: 1
    };
  }
}

export default builder;
