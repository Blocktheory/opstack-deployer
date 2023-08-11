import { useEffect, useState } from "react";
import { initWasm } from "@trustwallet/wallet-core";
import { Wallet } from '../../utils/wallet'
import { useAtom } from 'jotai'
import { atomWithStorage, RESET } from 'jotai/utils';
import FooterButtons from "./FooterButtons";
import Step2 from "./Step2";

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
    sequencer: sequencerAddr
  }
};

type Fields = {
  CHAIN_NAME: string;
  CHAIN_ID: number;
  ETH_RPC_URL: string;
};

interface IStep1Props {
  fields: Fields,
  setFields: Function

}


const addressFromStorage = atomWithStorage('address', await getAddress());



function Setup() {
  const [currStep, setStep] = useState(0);
  const [address, setAddress] = useAtom(addressFromStorage);
  const [fields, setFields] = useState({
    CHAIN_NAME: "",
    CHAIN_ID: 0,
    ETH_RPC_URL: ""
  });

  return (
    <>
      {currStep == 0 &&
        <Step1 fields={fields} setFields={setFields}></Step1>
      }
      {currStep == 1 &&
        <Step2 fields={fields} addressFromStorage={addressFromStorage}></Step2>
      }
      <FooterButtons currStep={currStep} onNext={() => setStep(1)} onBack={() => setStep(0)} onReset={() => { setAddress(RESET) }}></FooterButtons>

    </>
  )
}

export default Setup;


function Step1({ fields, setFields }: IStep1Props) {

  const [address, setAddress] = useAtom(addressFromStorage);
  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;

    setFields((prevState: any) => {
      return { ...prevState, [name]: value };
    });
  };


  return (
    <>
      <div className="mx-48">
        <h1 className="text-bold text-2xl my-5" >Initial Setup</h1>
        <div className="bg-white rounded p-6 shadow-md grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="w-full ">
            <label htmlFor="input1" className="block mb-1">Chain Id
            </label>
            <input onChange={handleInputChange} value={fields.CHAIN_ID} type="text" name="CHAIN_ID" id="input1" className=" w-full rounded  border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 1" />
          </div>
          <div className="w-full ">
            <label htmlFor="input2" className="block mb-1">Chain Name</label>
            <input onChange={handleInputChange} value={fields.CHAIN_NAME} type="text" name="CHAIN_NAME" id="input2" className="  w-full rounded border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 2" />
          </div>
          <div className="w-full ">
            <label htmlFor="input3" className="block mb-1">Layer 1 RPC URL</label>
            <input onChange={handleInputChange} value={fields.ETH_RPC_URL} type="text" name="RPC_URL" id="input3" className="  w-full rounded border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 3" />
          </div>
        </div>

        <h1 className="text-bold text-2xl my-5" >Wallet Setup </h1>
        <div className="bg-white  rounded p-6 shadow-md">
          <div className="p-4  grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
            <div className="w-full ">
              <label htmlFor="input1" className="block mb-1">Admin Public Address
              </label>
              <input disabled value={address.admin.publicAddr} type="text" id="input1" className="bg-gray-200 text-xs w-full rounded  border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 1" />
            </div>
            <div className="w-full ">
              <label htmlFor="input2" className="block mb-1">Admin Private Key</label>
              <input disabled value={address.admin.privateKey} type="text" id="input2" className="bg-gray-200 text-xs w-full rounded border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 2" />
            </div>
          </div>
          <p className="pb-4 p-2">Recommended ETH for Admin: <b>2 ETH</b></p>
          <hr />
          <div className="p-4  grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
            <div className="w-full ">
              <label htmlFor="input1" className="block mb-1">Sequencer Public Address
              </label>
              <input disabled value={address.sequencer.publicAddr} type="text" id="input1" className="bg-gray-200 text-xs w-full rounded  border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 1" />
            </div>
            <div className="w-full ">
              <label htmlFor="input2" className="block mb-1">Sequencer Private Key</label>
              <input disabled value={address.sequencer.privateKey} type="text" id="input2" className="bg-gray-200 text-xs  w-full rounded border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 2" />
            </div>
          </div>
          <hr />
          <div className="p-4 grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="w-full ">
              <label htmlFor="input1" className="block mb-1">Proposer Public Address
              </label>
              <input disabled value={address.proposer.publicAddr} type="text" id="input1" className="bg-gray-200 text-xs w-full rounded  border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 1" />
            </div>
            <div className="w-full ">
              <label htmlFor="input2" className="block mb-1">Proposer Private Key</label>
              <input disabled value={address.proposer.privateKey} type="text" id="input2" className="bg-gray-200 text-xs  w-full rounded border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 2" />
            </div>
          </div>
          <p className="pb-4 p-2" >Recommended ETH for Proposer: <b>5 ETH</b></p>

          <hr className="" />
          <div className=" p-4 grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="w-full ">
              <label htmlFor="input1" className="block mb-1">Batcher Public Address
              </label>
              <input disabled value={address.batcher.publicAddr} type="text" id="input1" className=" bg-gray-200 text-xs w-full rounded  border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 1" />
            </div>
            <div className="w-full ">
              <label htmlFor="input2" className="block mb-1">Batcher Private Key</label>
              <input disabled value={address.batcher.privateKey} type="text" id="input2" className="bg-gray-200 text-xs  w-full rounded border-grey-300 border-2 focus:border-blue-500 focus:ring focus:ring-blue-200 p-4" placeholder="Input 2" />
            </div>
          </div>
          <p>Recommended ETH for Batcher: <b>10 ETH</b></p>
        </div>
      </div>
    </>
  )
}



