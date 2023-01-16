import { ethers } from "ethers";

(async () => {
  const connection = new ethers.providers.JsonRpcProvider('https://palpable-aged-pine.rinkeby.discover.quiknode.pro/e165bb8d2cc4947dc8c66398c3b0653653b4a2cb/');
  
  const gasPrice = connection.getGasPrice();
  const wallet = ethers.Wallet.fromMnemonic('dentist live length stand special illness luggage usual tag they grass rent');
  const signer = wallet.connect(connection);

  const recipient = '0x1BaB8030249382A887F967FcAa7FE0be7B390728';

  const tx = {
    from: wallet.address,
    to: recipient,
    value: ethers.utils.parseUnits('0.001', 'ether'),
    gasPrice: gasPrice,
    gasLimit: ethers.utils.hexlify(10000000), // 100 gwei
    nonce: connection.getTransactionCount(wallet.address, 'latest')
  };

  const transaction = await signer.sendTransaction(tx);

  console.log(transaction);
})();