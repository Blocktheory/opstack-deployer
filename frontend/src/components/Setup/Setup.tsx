import { useEffect, useState } from "react";
import { initWasm } from "@trustwallet/wallet-core";
import { Wallet } from '../../utils/wallet'
import { useAtom } from 'jotai'
import { atomWithStorage, RESET } from 'jotai/utils';
import FooterButtons from "./FooterButtons";
import Step2 from "./Step2";
import Step3 from "./Step3";


type Fields = {
  CHAIN_NAME: string;
  CHAIN_ID: number;
  ETH_RPC_URL: string;
};

interface IStep1Props {
  fields: Fields,
  setFields: Function

}


const addressFromStorage = atomWithStorage('address', {});



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
      {
        currStep == 1 &&
        <Step2 address={address} setAddress={setAddress}></Step2>

      }
      {currStep == 2 &&
        <Step3 fields={fields} addressFromStorage={addressFromStorage}></Step3>
      }
      <FooterButtons currStep={currStep} onNext={() => setStep((prev) => prev + 1)} onBack={() => setStep((prev) => prev - 1)} onReset={() => { setAddress(RESET) }}></FooterButtons>

    </>
  )
}

export default Setup;


function Step1({ fields, setFields }: IStep1Props) {

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;

    setFields((prevState: any) => {
      return { ...prevState, [name]: value };
    });
  };


  return (
    <>
      <div className="md:mx-24 lg:mx-48">
        <h1 className="text-bold text-2xl my-5" >Initial Setup</h1>
        <div className="bg-white rounded p-6 shadow-md grid grid-cols-1  gap-4">
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
      </div>
    </>
  )
}



