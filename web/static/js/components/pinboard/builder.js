const builder = {
  addImageAndFrame(svg, group, data, item) {
    if(item.resource) {
      let currentData = { ...data };
      this.getImageSize(item.resource.url.thumb, (width, height) => {
        let currentWidth = width;
        let currentHeight = height;

        if (currentHeight > currentData.height) {
          currentWidth = currentWidth * currentData.height / currentHeight;
          currentHeight = currentData.height;
        }
        if (currentWidth > currentData.width) {
          currentHeight = currentHeight * currentData.width / currentWidth;
          currentWidth = currentData.width;
        }
        currentData.width = currentWidth;
        currentData.height = currentHeight;

        let rect = this.createMainRect(svg, currentData, item);
        let image = this.createMainImage(svg, currentData, item);
        this.addDeleteButton(rect, image, svg, group, currentData, item);
      });
    } else {
      let rect = this.createMainRect(svg, data, item);
      group.add(rect);
    }
  },
  addDeleteButton(rect, image, svg, group, data, item) {
    let semi = group.group();
    semi.add(rect, image);

    if(item.permissions.can_delete) {
      // Disable by https://rally1.rallydev.com/#/9459752931d/detail/task/60306650946
      // let remove = this.createDeleteImage(svg, data, item);
      // group.add(semi, remove);
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
    let itemsInRow = this.isVerticalMobile() ? 3 : 4;
    if(data.item % itemsInRow == 0) {
      data.x = startX;
      data.y += data.spaceTop + data.height + data.border*2;
    }
    else {
      data.x += data.spaceSide + data.width + data.border*2;
    }
    data.item++;
  },
  getImageSize(url, callback) {
    var img = new Image();
    img.src = url;
    img.onload = function() {
      callback(this.width, this.height);
    }
  },
  isMobile() {
    return screen.width < 768 && screen.height < 768;
  },
  isVerticalMobile() {
    return this.isMobile() && screen.height > screen.width;
  },
  isHorizontalMobile() {
    return this.isMobile() && screen.height < screen.width;
  },
  startingData() {
    let width = this.isVerticalMobile() ? 270 : 180;
    let height = this.isHorizontalMobile() ? width / 3 : width / 1.45;
    return {
      x: 45,
      y: 55,
      width: width,
      height: height,
      spaceTop: 55,
      spaceSide: 10,
      border: 10,
      item: 1
    };
  }
}

export default builder;
