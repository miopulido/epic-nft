require("@nomiclabs/hardhat-waffle");

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/-TNpdHYBocL5Uej3-enIEG3m2zrCkz_B",
      accounts: [
        "4457e5d3db8c67831fd9d3d5fc0af40e3429dc364dae955f23211d5a5bea6dcb",
      ],
    },
  },
};
