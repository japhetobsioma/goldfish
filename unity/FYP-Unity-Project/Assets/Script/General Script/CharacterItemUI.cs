using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.Events;

public class CharacterItemUI : MonoBehaviour
{
    [SerializeField] Color itemNotSelectedColor;
    [SerializeField] Color itemSelectedColor;

    [Space(20f)]
    [SerializeField] Image characterImage;
    [SerializeField] TMP_Text characterNameText;
    [SerializeField] TMP_Text characterPriceText;
    [SerializeField] Button characterPurchaseButton;

    [Space(20f)]
    [SerializeField] Button ItemButton;
    [SerializeField] Image ItemImage;
    [SerializeField] Outline ItemOutline;

    //--------------------------------------//

    public void SetItemPosition(Vector2 pos)
    {
        GetComponent<RectTransform>().anchoredPosition += pos;
    }

    public void SetCharacterImage(Sprite sprite)
    {
        characterImage.sprite = sprite;
    }

    public void SetCharacterName(string name)
    {
        characterNameText.text = name;
    }

    public void SetCharacterPrice(int price)
    {
        characterPriceText.text = price.ToString();
    }

    public void SetCharacterAsPurchased()
    {
        characterPurchaseButton.gameObject.SetActive(false);
        ItemButton.interactable = true;

        ItemImage.color = itemNotSelectedColor;
    }

    public void OnItemPurchase(int itemIndex, UnityAction<int> action)
    {
        characterPurchaseButton.onClick.RemoveAllListeners();
        characterPurchaseButton.onClick.AddListener (() => action.Invoke (itemIndex));
    }

    public void OnItemSelect(int itemIndex, UnityAction<int> action)
    {
        ItemButton.interactable = true;
        ItemButton.onClick.RemoveAllListeners();
        ItemButton.onClick.AddListener(() => action.Invoke(itemIndex));
    }

    public void SelectItem()
    {
        ItemOutline.enabled = true;
        ItemImage.color = itemSelectedColor;
        ItemButton.interactable = false;
    }

    public void DeselectItem()
    {
        ItemOutline.enabled = false;
        ItemImage.color = itemNotSelectedColor;
        ItemButton.interactable = true;
    }

}
