#!/bin/bash

clusters_ids="'babb56c4-baf9-41f8-aac6-b0227d245cb1', '89250083-c5d2-495a-9657-4df792300768', '2fcc428b-3bdc-49ee-acaf-6cf7d31dd935', '0fdd3b6f-0cd1-4f23-b0ca-fc36378366e2', 'b795b8f7-ad00-4fc7-8f42-a2a9d2e40ad5', 'df08221b-8dab-442a-8613-d458b7bab186', 'd71815aa-f323-49c5-a1e7-f57e5d661890', 'fc1dfa97-e04d-45cb-a1c4-b79ef1839528', 'a409d082-5235-49ad-bfa9-6c8449edc7be', '6cfe4150-6fa2-477e-869c-fa329e272904', '259391dc-e845-4f2d-a94c-a6ac49dfbd1c', '023e6d2b-4b15-4280-80db-a66c09b9a6f3', '8f79a11b-44e0-4496-aadb-076def65ee00', '8e28d6dd-2ca3-4dfc-9dbe-5b6e01bd1928', '5414015e-edb3-4b9a-a489-5e6af56984ff', '44e81947-f1e6-4454-9ffc-0558f6d75e43', 'f817073e-b5bd-41c0-a0db-8fa5e8b0198d', '4dc4e084-eda7-44fa-8319-eec270fca851', '4d6e84db-458c-4dd8-be95-cdd52ce91b15', '1c5d7ed7-b643-4f43-badd-ebc1fc5dee40', '595e56b0-95da-41f6-9723-f4728f657c07', 'e50c3c34-1e32-437f-ab5b-787523d9cfd9', '7fb052fc-5572-4562-a8f9-3fcd30be8a6b', 'a9b2407a-5252-47b2-903c-359ad6f509a6', 'e518b70b-c641-491e-9d86-57da603db751', '058da27c-7f26-4711-8770-d0a50cdd4b57', 'd57ccde5-7e15-465c-8a4b-163449ade88d', 'e2f05cff-b4a1-47e8-8783-1b644f1edf12', '20b0b34e-4dea-4bc0-9e2f-77af84154641', 'f3a07b36-8e08-4281-8637-cec724f5fec8', '985e847c-7faa-48d4-b478-e01f5a47ccc2', '08f2796b-58c0-4a79-a826-4e1a94ec9481', '33938773-5fa8-41ca-8745-9eacda413ad1', 'd4c11783-800a-4b88-b39e-c9e96c5befb6', 'c15e12f9-d8cc-46aa-a803-b5c3ec541186', '5c522a07-135d-44c3-a0b2-5ba5c3530552', '599eed13-2444-41da-b4e8-0a5f9eb170ba', '9a283f5e-83bc-4bb4-ac68-37ad4d5cd825', '19d8c699-dfa4-4fc8-b95f-b657d52c5d59', 'ea5fefa3-4b7c-4672-89d7-a542b642217a', 'c2554b62-6bea-4573-a780-25bc21f8334d', 'afc68891-3ede-4fee-b94f-a3c6c27d48fa', '7a2a5129-deda-4cb6-b19b-6764190b65d2', 'a969e2fb-628e-4f95-b418-edf6fc145fce', '93d03c27-325f-4a6b-ae15-01a886978543', '0928803b-f17e-4914-b5ca-810bdd156a23', '797250ab-106c-4cd6-9ce9-85fbc5b8c3e2', '78f906f0-d5db-40b7-82dc-22e98180acef', '5d353200-ab66-4e55-84fa-5385a611e70c', '4649d954-8719-4d28-beaf-849f2b64a90f', 'ad0a7144-cb24-4415-abe8-5e4f554374e0', '2c4062af-08d1-481f-a13a-f02403b0003f', '48e96191-8403-49f6-a994-9f2e5fc57fd7', '931ad22d-1859-4075-b9c8-4fd988494ab1', 'a3826624-bdf1-4e47-9b33-df4ecaac8799', '520f3bf5-4c65-4233-b0b1-7044243eb34d', '6f710cd4-779d-400c-8620-2ea83d7634c9', '942f1806-8c1d-47ef-8d71-db84035b3704', 'c6b6c555-b97e-4866-bc1d-c3b3fcfc0360', 'd97788d7-893d-4190-a8db-11e57a31e940', 'a7fa271a-1d48-4cd5-af6d-9d2f26e38f6d', 'c4564f9a-32a2-4d3c-a5d5-908d2ee47c4c', '010167af-7637-4b17-bb7d-91251cb7b6a1', '967fa9f5-231b-49e7-b1a0-df6dbf84b92a', '18378f4b-6856-4265-835d-f93d983d4a01', 'e6c4bc06-3366-4183-a1e8-b1cfbd8c9271', 'c8bcd8a4-9622-4111-9250-d6f7ae6fd8ad', '42489f9e-7c11-4931-ab88-c52d22e87cb2', '6735fbe3-3439-43e1-aec2-5aeba1f8db5c', '9669ded9-d167-4bb9-9b3f-8c1a2fd17f08', 'd180830c-8e16-4b81-a90a-342ed972f0f5', '5e15f482-7195-4cf0-9841-223bcaa02e1b', '66fbdb32-6b0b-493f-afbb-c466fd225ea5', 'b87e8ef0-7d6b-4f50-b850-cae65e4c6cf4', 'ef9500fa-b957-40d7-b7af-36c4eef40c9e', '8c05b7b2-beab-49d8-b192-15dc784f66d2', '76ee31a8-53fd-4b22-8b4b-07b616acb443', '01219db8-3af6-4be1-9643-9005e2a18b4a', '041bd333-3a07-4cc1-8de7-a5569642303e', '44a648fe-62c9-42c5-b193-2119cbf1b1e8', '1fc50532-a261-4025-b4b8-ac0e6ebdfd79', '11c88131-1122-472b-879b-c5495ddbf552', '7d1ffc04-6cd5-4774-9638-da01ac398e24', '05195408-fcc7-47be-afa9-112f3bd97ad0', '059a6147-6091-444e-a636-912e3c771f4b', 'fb430e1a-cea7-44ee-b560-50dd5b9d22e0', 'abd39fd1-4033-40fb-9f4a-e295fbdaf9c0', '4be2fe30-d627-4bc7-8211-765e367668f7', '4373c079-8a92-4e5e-bbf8-7b30d53895d6', '1daaf3bf-0adc-4cae-8c5e-461453f82a58', 'b409b7a1-0805-435e-a973-b9abbb0cd49a', '9f27d1bc-e79e-4bd1-a716-eb762e597c8f', '00cf545c-843f-426f-97a1-adfa08a0876a', 'e243fed5-f547-4a0a-a27d-c7a2b095792a', '97fea488-1236-446b-bceb-1327063cd366', '94beef4a-e571-4bef-9e3c-4d35b865e216', '4495cf50-79c8-444e-a6ad-383e7811c973', '1ccfe27c-468a-4952-9fb1-e4c380047e4b', 'bf24b31e-2da8-4f3c-952c-d179140ceb01', '8e777bcc-3e5a-44fc-9c12-44994e54c078', 'dfeb248c-eafe-4998-bf59-03efbfe50c8c', 'c561c568-0807-41d2-b95d-2f1b292b7a3b', 'd3a3b3a2-ac31-41a2-a0b7-1c1cdbc1d912', 'a8d445f0-6db1-47c3-9516-ad2cee8415f8', 'b708c509-6d9a-4f68-8455-bfb3fb768101', 'bf5f3798-b6a3-4572-b5d1-530307c415c6', '52900bc9-0374-4e8f-90e5-ce20402455af', '061b133b-72b7-486a-adc8-5ea3aeec6e6f', 'cb428c66-40fa-496e-9f86-7d5eb8634556', '9d0adf69-e3a0-4464-8d44-8bbeaa283ae0', 'd71a551f-0cc5-42f6-8290-1fab94f4e590', 'a2332646-d4c1-4dd6-875c-f958ea1e75bf', '18680df3-2723-47de-aad3-6fcb53188401', 'b45e1a0c-7902-4d93-97c6-1262ad6c738e', 'd5c903ac-52b9-498a-b47b-ad9cc8232395', '20fdd9dd-dbe2-4e8f-aaf4-b88ee72279dd', 'be4ab611-dc52-441d-9a50-5c94c54ef313', 'cbf66e4c-753a-4fa5-bf6b-3ef6938ee525', '0b55191c-660c-419a-b77d-f4a86b3e8371', 'd8c1665d-5fc0-4221-9879-3d01f6b2ef99', '6ea11f49-1313-4af1-910d-8ce84330c678', '3234527a-7528-4d69-9c72-24adce33aab2', '60e00120-8235-4a7c-95d8-577716b121fc', '3c37b638-8cb1-4567-9367-fc47a40ac0fc', '4ffd45f4-e627-4954-9723-d9d7fd86a130', '706f4aa2-4ebf-48e5-8d7a-a04fffbe5af6', '91f25955-e9cf-48f0-a087-b0a4d7f1492e', '2784e25a-f938-4ecf-80f4-ce1adcf3cb8a', '36fe92a1-3463-43aa-8cf1-855653f9162a', '234224da-a8ec-4027-8031-524e71db780b', '64b00937-b2e6-4b51-a132-8461dc55e198', 'cfa8b11e-b091-4ad0-a63b-b47115f87afa', '3fc02db7-643d-4b8f-89fe-fd2a00ca26cc', '00a2b136-cfe9-4eab-8b49-595797ab637f', 'bee3c71f-c5e0-416a-b4c9-4525660872d7', '55616a6f-de5b-4228-92a8-ab1a30895063', '4d1cb6b3-8b6f-45dc-8bab-ce257d3d00f9', '4f6e0377-7354-4c28-bb02-215171ed14a2', 'b41b1d7c-333a-4a0d-bce4-414ad03821c5', '32cdc5bb-2c1d-490b-b10e-3feb6bd2ef1a'"

clusters_ids=("${clusters_ids//,}")

for cid in ${clusters_ids[@]}; do

    cid="${cid//\'}"
    cluster=$(curl -s https://api.openshift.com/api/assisted-install/v1/clusters/$cid -H "Authorization: bearer $(ocm token)")
    err=$(echo $cluster | jq '.code')
    if [[ $err == '"404"' ]]; then
        continue
    fi
    events=$(curl -s https://api.openshift.com/api/assisted-install/v1/clusters/$cid/events -H "Authorization: bearer $(ocm token)")

    id=$(echo $cluster | jq '.id')
    status=$(echo $cluster | jq '.status')
    echo ===============================================================================================================================
    echo id: $id
    echo status: $status
    echo -------------------------------------------------------------------------------------------------------------------------------
    echo $events | \
        jq '.[].message' | \
        grep -E "validation .* that used to succeed is now failing|validation .* is not fixed" | \
        sort | \
        uniq -c | \
        sort -nrk1
    echo -------------------------------------------------------------------------------------------------------------------------------
    hosts_names=($(echo $cluster | jq '.hosts[].requested_hostname'))
    hosts_statuses=($(echo $cluster | jq '.hosts[].status'))
    for i in $(seq 1 ${#hosts_names[@]});do
        index="$(($i-1))"
        echo ${hosts_names[$index]}: status\(${hosts_statuses[$index]}\)
    done
    echo ===============================================================================================================================
done
