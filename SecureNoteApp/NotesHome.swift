//
//  NotesHome.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import SwiftUI

struct NotesHome: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: SecureNote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SecureNote.created, ascending: true)]) var notes: FetchedResults<SecureNote>
    
    @State private var showAdd = false
    
    var body: some View {
        List {
            ForEach(notes, id: \.self) { secureNote in
                NavigationLink(destination: NoteDetailView(note: secureNote)) {
                    NoteCell(isSecured: secureNote.isSecured, text: secureNote.note ?? "")
                }
            }
        }
        .navigationBarTitle("Secure Notes")
        .navigationBarItems(trailing: Button(action: { self.showAdd.toggle() }) {
            Text("Create")
        }).sheet(isPresented: $showAdd) { 
            AddNewNote(showAdd: self.$showAdd).environment(\.managedObjectContext, self.moc)
        }
    }
}

struct NotesHome_Previews: PreviewProvider {
    static var previews: some View {
        NotesHome()
    }
}
