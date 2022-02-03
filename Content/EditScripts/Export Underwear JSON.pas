{
  Export spells, perks, items, shouts and leveled items-spells for Spell Perk Item Distributor
}
unit ExportSPI;

var
  slExport: TStringList;
  modname: string;
  typename: string;
  buffer: string;

  
function Initialize: integer;
  begin
    slExport := TStringList.Create;
    modname := '';
    InputQuery('Item Type', 'Type', typename);
    slExport.Add('{');
  end;

procedure FinishMod();
begin
  if modname <> '' then
  begin
      slExport.Add(buffer);
      slExport.Add(']');
      buffer := '';
      end;
end;

function Process(e: IInterface): integer;  
  var 
    currentMod: string;
    
begin 
  if Signature(e) <> 'ARMO' then Exit;
   
  currentMod:= GetFileName(MasterOrSelf(e));
      if currentMod <> modName then
        begin
          FinishMod();
          if modName <> '' then
          begin
                slExport.Add('},');
          end;

          modName := currentMod;
          slExport.Add('"' + currentMod + '": {');
          slExport.Add('"' + typename + '": [');  
        end;
    
    if buffer <> '' then
        begin
          slExport.Add(buffer + ',');
        end;

      buffer := '{ "id": "' + IntToHex(FormID(e) and $FFFFFF, 8) + '", "name": "' + EditorID(e) + '" }';    
end;

function Finalize: integer;
var
  dlgSave: TSaveDialog;
  ExportFileName: string;
begin
    FinishMod();
    slExport.Add('}'); 
    slExport.Add('}'); 

  if slExport.Count <> 0 then 
  begin
  dlgSave := TSaveDialog.Create(nil);
    try
      dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
      dlgSave.Filter := 'JSON (*.json)|*.json';
      dlgSave.InitialDir := 'C:\Users\sam\Documents\Projects\smalls';
      dlgSave.FileName := modname + '_Underwear.json';
  if dlgSave.Execute then 
    begin
      ExportFileName := dlgSave.FileName;
      AddMessage('Saving ' + ExportFileName);
      slExport.SaveToFile(ExportFileName);
    end;
  finally
    dlgSave.Free;
    end;
  end;
    slExport.Free;
end;

end.
