import { Button, TextView, contentView, device } from 'tabris';

contentView.append(
  <Button centerX text='Show message' onSelect={() => {
    $(TextView).only().text = 'Tabris.js @ rocks!';
  }}
  />,
  <TextView centerX top="prev() 50" font="24px" />
);
console.log(device.cameras)