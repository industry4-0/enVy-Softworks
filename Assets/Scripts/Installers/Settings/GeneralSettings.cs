using UnityEngine;
using Zenject;

[CreateAssetMenu(fileName = "GeneralSettings", menuName = "Installers/GeneralSettings")]
public class GeneralSettings : ScriptableObjectInstaller<GeneralSettings>
{
    public Maketo.Settings MaketoSettings;
 
    public override void InstallBindings()
    {
        Container.BindInstance(MaketoSettings);
    }
}