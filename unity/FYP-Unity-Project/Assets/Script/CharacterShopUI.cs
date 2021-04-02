using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CharacterShopUI : MonoBehaviour
{
    [Header("Layout Settings")]
    [SerializeField] float itemSpacing = .5f;
    float itemHeight;

    [Header("UI Elements")]
    [SerializeField] Transform ShopMenu;
    [SerializeField] Transform ShopItemContainer;
    [SerializeField] GameObject ItemPrefab;
    [Space(20)]
    [SerializeField] CharacterShopDatabase characterDB;


    [Header ("Shop Events")]
    [SerializeField] GameObject shopUI;
    [SerializeField] Button openShopButton;
    [SerializeField] Button closeShopButton;

    int newSelectedItemIndex = 0;
    int previousSelectedItemIndex = 0;

    // Start is called before the first frame update
    void Start()
    {
        AddShopEvents();
        GenerateShopItemUI();
    }

    void GenerateShopItemUI()
    {
        //delete ItemTemplate after calculating items height
        itemHeight = ShopItemContainer.GetChild (0).GetComponent<RectTransform>().sizeDelta.y;
        Destroy(ShopItemContainer.GetChild(0).gameObject);
        ShopItemContainer.DetachChildren();

        //Generate item
        for (int i = 0; i < characterDB.CharactersCount; i++)
        {
            Character character = characterDB.GetCharacter(i);
            CharacterItemUI uiItem = Instantiate(ItemPrefab, ShopItemContainer).GetComponent <CharacterItemUI> ();

            //move item to its position
            uiItem.SetItemPosition(Vector2.down * i * (itemHeight + itemSpacing));

            //set item name in hierarchy
            uiItem.gameObject.name = "Item" + i + "-" + character.name;

            //Add information to the UI (one time)
            uiItem.SetCharacterName(character.name);
            uiItem.SetCharacterImage(character.image);
            uiItem.SetCharacterPrice(character.price);

            if (character.isPurchased)
            {
                //character is purchased
                uiItem.SetCharacterAsPurchased();
                uiItem.OnItemSelect(i, OnItemSelected);
            }
            else
            {
                uiItem.SetCharacterPrice(character.price);
                uiItem.OnItemPurchase(i , OnItemPurchase);
            }

            //Resize item container
            ShopItemContainer.GetComponent<RectTransform>().sizeDelta =
                Vector2.up * ((itemHeight + itemSpacing) * characterDB.CharactersCount + itemSpacing);

        }

    }

    void OnItemSelected(int index)
    {
        //select item on the UI
        SelectItemUI(index);
    }

    void SelectItemUI(int itemIndex)
    {
        previousSelectedItemIndex = newSelectedItemIndex;
        newSelectedItemIndex = itemIndex;

        CharacterItemUI prevUiItem = GetItemUI(previousSelectedItemIndex);
        CharacterItemUI newUiItem = GetItemUI(newSelectedItemIndex);


    }

    CharacterItemUI GetItemUI(int index)
    {
        return ShopItemContainer.GetChild(index).GetComponent<CharacterItemUI>();
    }

    void OnItemPurchase(int index)
    {
        Character character = characterDB.GetCharacter(index);
        CharacterItemUI uiItem = GetItemUI(index);

        if (GameDataManager.CanSpendWater(character.price))
        {
            //proceed with purchase operation
            GameDataManager.SpendWater(character.price);

            //Update Coin UI text
            GameSharedUI.Instance.UpdateCoinsUIText();

            Instantiate(character.fish, new Vector3(0, 20, 0), transform.rotation);

        }
        else
        {
            Debug.Log("Not enough water");
        }
    }

    void AddShopEvents()
    {
        openShopButton.onClick.RemoveAllListeners();
        openShopButton.onClick.AddListener(OpenShop);

        closeShopButton.onClick.RemoveAllListeners();
        closeShopButton.onClick.AddListener(CloseShop);

    }

    void OpenShop()
    {
        shopUI.SetActive(true);
    }

    void CloseShop()
    {
        shopUI.SetActive(false);
    }
}
