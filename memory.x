MEMORY
{
  /* NOTE 1 K = 1 KiBi = 1024 bytes */
  /* main reason why I am using nrf52840 is to ensure ram is plentiful */
  FLASH (rx) : ORIGIN = 0x00027000, LENGTH = 868K
  RAM (rwx) : ORIGIN = 0x20020000, LENGTH = 128K
}
