import mobileScreenHelpers from '../../mixins/mobileHelpers';

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

        let rect = this.createMainRect(group, currentData, item);
        let image = this.createMainImage(group, currentData, item);
        this.addDeleteButton(rect, image, group, currentData, item);
      });
    } else {
      let rect = this.createMainRect(group, data, item);
      group.add(rect);
    }
  },
  addDeleteButton(rect, image, group, data, item) {
    if(item.permissions.can_delete) {
       this.createDeleteImage(group, data, item);
    }
  },
  createMainRect(svg, data, item) {
    return svg.rect(data.width + data.border, data.height + data.border, 5).attr({ fill: 'white', stroke: item.colour, 'stroke-width': data.border, x: data.x, y: data.y });
  },
  createMainImage(svg, data, item) {
    return svg.image(item.resource.url.thumb, data.width, data.height).attr({ x: data.x + data.border/2, y: data.y + data.border/2 });
  },
  createDeleteImage(svg, data, item) {
    let remove = svg.image('/images/svgControls/remove.png', 26, 26).attr({x: data.x+data.width-data.border+4, y: data.y-data.border,});
    return remove.addClass('cursor-pointer remove-button').click(this.removePinboardResource.bind(this, item.id));
  },
  setNextPositionForPinboard(startX, data, item) {
    if(data.item) {
      data.x += data.spaceSide + data.width + data.border*2;
      if (data.x + data.width >= 925) {
        data.x = startX;
        data.y += data.spaceTop + data.height + data.border*2;
      }
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
  startingData() {
    let width = mobileScreenHelpers.isVerticalMobile() ? 270 : 180;
    let height = mobileScreenHelpers.isHorizontalMobile() ? width / 3 : width / 1.45;
    return {
      x: 45,
      y: 35,
      width: width,
      height: height,
      spaceTop: 35,
      spaceSide: 10,
      border: 10,
      item: 1
    };
  }
}

export default builder;
