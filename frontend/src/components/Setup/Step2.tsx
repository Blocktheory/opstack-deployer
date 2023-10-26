import { useState } from "react";
import Loader from "../UI_Components/Loader";
import { initWasm } from "@trustwallet/wallet-core";
import { Wallet } from "../../utils/wallet";
import { useAtom } from "jotai";
import { Input } from "../UI_Components/Input";

const getAddress = async () => {
  // Creating Address for the required accounts for deploying the blockchain
  const walletCore = await initWasm();
  const admin = new Wallet(walletCore);
  const proposer = new Wallet(walletCore);
  const batcher = new Wallet(walletCore);
  const sequencer = new Wallet(walletCore);

  const adminAddr = await admin.createAccount();
  const proposerAddr = await proposer.createAccount();
  const batcherAddr = await batcher.createAccount();
  const sequencerAddr = await sequencer.createAccount();

  return {
    admin: adminAddr,
    proposer: proposerAddr,
    batcher: batcherAddr,
    sequencer: sequencerAddr,
  };
};

function Step2({ address, setAddress, createFlagAtom }: any) {
  const [createFlag, setCreateFlag] = useAtom(createFlagAtom);
  const [loading, setLoading] = useState(false);

  //disabled -> If accounts are not created.

  const handleWalletCreate = async () => {
    setLoading(true);
    const addr = await getAddress();
    setAddress(addr);
    setTimeout(() => {
      setCreateFlag(true);
      setLoading(false);
    }, 1000);
  };

  return (
    <div className="md:mx-24 lg:mx-52 mt-9 w-[60%] !mx-auto">
      <h1 className="font-bold text-2xl my-5 mb-4 font-sans text-[#101521CC]">
        Wallet Setup{" "}
      </h1>
      <p className="font-medium text-base text-[#797F8A]">
        Create wallets for Admin, Batcher, Sequencer and Proposer
      </p>

      {loading ? (
        <div className="md:mx-24 lg:mx-48 ">
          <div className="flex justify-center mt-10">
            <Loader></Loader>
          </div>
        </div>
      ) : !createFlag ? (
        <div className="flex justify-center mt-10">
          <button
            onClick={handleWalletCreate}
            className="text-xl mx-2 rounded-full border bg-white  text-black hover:bg-black hover:text-white font-semibold py-3 px-10"
          >
            Create Wallets
          </button>
        </div>
      ) : (
        <div className="bg-white rounded-2xl p-6 shadow-2xl mt-6 mb-8">
          <div className="py-4 grid grid-cols-1 md:grid-cols-2 gap-4 pb-1.5">
            <div className="w-full ">
              <Input
                htmlFor="input1"
                spanName="Admin"
                name="Public Address"
                inputId="input1"
                inputType="text"
                inputValue={address.admin.publicAddr}
              />
            </div>
            <div className="w-full ">
              <Input
                htmlFor="input2"
                spanName="Admin"
                name="Private Key"
                inputId="input2"
                inputType="text"
                inputValue={address.admin.privateKey}
                isPrivate={true}
              />
            </div>
          </div>
          <p className="pb-4 font-sans text-xs italic text-[#101521CC]">
            Recommended ETH for Admin: <b>2 ETH</b>
          </p>
          <hr />
          <div className="py-4  grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
            <div className="w-full ">
              <Input
                htmlFor="input1"
                spanName="Sequencer"
                name="Public Address"
                inputId="input2"
                inputType="text"
                inputValue={address.sequencer.publicAddr}
              />
            </div>
            <div className="w-full ">
              <Input
                htmlFor="input1"
                spanName="Sequencer"
                name="Private Key"
                inputId="input2"
                inputType="text"
                inputValue={address.sequencer.privateKey}
                isPrivate={true}
              />
            </div>
          </div>
          <hr />
          <div className="py-4 grid grid-cols-1 md:grid-cols-2 gap-4 pb-1.5">
            <div className="w-full ">
              <Input
                htmlFor="input1"
                spanName="Proposer"
                name="Public Address"
                inputId="input2"
                inputType="text"
                inputValue={address.proposer.publicAddr}
              />
            </div>
            <div className="w-full ">
              <Input
                htmlFor="input1"
                spanName="Proposer"
                name="Private Key"
                inputId="input2"
                inputType="text"
                inputValue={address.proposer.privateKey}
                isPrivate={true}
              />
            </div>
          </div>
          <p className="pb-4 text-xs italic text-[#101521CC]">
            Recommended ETH for Proposer: <b>5 ETH</b>
          </p>

          <hr className="" />
          <div className="py-4 grid grid-cols-1 md:grid-cols-2 gap-4 pb-1.5">
            <div className="w-full ">
              <Input
                htmlFor="input1"
                spanName="Batcher"
                name="Public Address"
                inputId="input1"
                inputType="text"
                inputValue={address.batcher.publicAddr}
              />
            </div>
            <div className="w-full ">
              <Input
                htmlFor="input2"
                spanName="Batcher"
                name="Private Key"
                inputId="input2"
                inputType="text"
                inputValue={address.batcher.privateKey}
                isPrivate={true}
              />
            </div>
          </div>
          <p className="text-xs italic text-[#101521CC]">
            Recommended ETH for Batcher: <b>10 ETH</b>
          </p>
        </div>
      )}
    </div>
  );
}

export default Step2;
