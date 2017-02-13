import { Socket } from 'phoenix';

const socket = new Socket('/admin', {
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); },
});

const channel = socket.channel(`logs:pull`);
  if (channel.state != 'joined') {
    channel.join()
    .receive('ok', (resp) => {
      console.log(resp);
    })
    .receive('error', (error) =>{
      console.log(error);
    });
  }
socket.connect();
